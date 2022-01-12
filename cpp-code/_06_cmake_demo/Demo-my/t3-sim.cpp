#include <stdio.h>
#include <math.h>

#include "oneapi/dnnl/dnnl.hpp"
#include "oneapi/dnnl/dnnl_debug.h"

#include "example_utils.hpp"

using namespace dnnl;

void convtest(engine::kind engine_kind){
    
    using tag = memory::format_tag;
    using dt = memory::data_type;

    int arg[7] = {3, 227, 227, 11, 4, 96, 0};

    // onednn prepare    
    engine eng(engine_kind, 0); // 创建engine
    stream engine_stream(eng);  // 创建stream

    // host prepare
    int batch=100, input_c=arg[0], input_h=arg[1], input_w=arg[2];
    int filter_size=arg[3], stride=arg[4], padding=arg[6];
    int output_c=arg[5];
    int output_h = (input_h - filter_size + 2*padding) / stride + 1;   // 卷积向下取整
    int output_w = (input_w - filter_size + 2*padding) / stride + 1;

    // host data
    std::vector<float> src_v(batch * input_c * input_h * input_w);
    std::vector<float> dst_v(batch * output_c * output_h * output_w);
    std::vector<float> weight_v(output_c * input_c * filter_size * filter_size);
    std::vector<float> bias_v(output_c);

    for (size_t i = 0; i < src_v.size(); ++i)
        src_v[i] = 1.0f;
    for (size_t i = 0; i < weight_v.size(); ++i)
        weight_v[i] = 0.1f;
    for(size_t i = 0; i < bias_v.size(); ++i)
        bias_v[i] = 0;

    
    // tensor dimensions
    memory::dims conv_src_tz = {batch, input_c, input_h, input_h};
    memory::dims conv_weights_tz = {output_c, input_c, filter_size, filter_size};
    memory::dims conv_bias_tz = {output_c};
    memory::dims conv_dst_tz = {batch, output_c, output_h, output_h};
    memory::dims conv_strides = {stride, stride};
    memory::dims conv_padding = {arg[6], arg[6]};

    std::cout<<"input tensor: ";
    for(int i=0; i<3; i++)
        std::cout<<conv_src_tz[i]<<"×";
    std::cout<<conv_src_tz[3]<<"\n";
    
    std::cout<<"filter: ";
    for(int i=0; i<3; i++)
        std::cout<<conv_weights_tz[i]<<"×";
    std::cout<<conv_weights_tz[3]<<"\n";

    // create memory descriptions 
    auto conv_src_md = memory::desc({conv_src_tz}, dt::f32, tag::nchw);
    auto conv_bias_md = memory::desc({conv_bias_tz}, dt::f32, tag::x);
    auto conv_weights_md = memory::desc({conv_weights_tz}, dt::f32, tag::oihw);
    auto conv_dst_md = memory::desc({conv_dst_tz}, dt::f32, tag::nchw);
    

    // init memory
    
    auto user_src_memory = sycl_interop::make_memory(conv_src_md, eng, sycl_interop::memory_kind::buffer);
    auto user_weights_memory = sycl_interop::make_memory(conv_weights_md, eng, sycl_interop::memory_kind::buffer);
    auto user_bias_memory = sycl_interop::make_memory(conv_bias_md, eng, sycl_interop::memory_kind::buffer);
    auto conv_dst_memory = sycl_interop::make_memory(conv_dst_md, eng, sycl_interop::memory_kind::buffer);

    // create convolution_forward description
    auto conv_desc = convolution_forward::desc(prop_kind::forward_inference,
        algorithm::convolution_direct, conv_src_md, conv_weights_md,
        conv_bias_md, conv_dst_md, conv_strides, conv_padding,
        conv_padding);

    // create primitive description (convolution forward)
    auto conv_prim_desc = convolution_forward::primitive_desc(conv_desc, eng);    
    
    // create primitive (convolution forward)
    auto conv = convolution_forward(conv_prim_desc);

    // data buffer
    write_to_dnnl_memory(src_v.data(), user_src_memory);
    write_to_dnnl_memory(weight_v.data(), user_weights_memory);
    write_to_dnnl_memory(bias_v.data(), user_bias_memory);

    // forward propagate
    conv.execute(
        engine_stream,
        {
            {DNNL_ARG_SRC, user_src_memory},
            {DNNL_ARG_WEIGHTS, user_weights_memory},
            {DNNL_ARG_BIAS, user_bias_memory},
            {DNNL_ARG_DST, conv_dst_memory}
        }
    );
    
    engine_stream.wait();

    read_from_dnnl_memory(dst_v.data(), conv_dst_memory);
    std::cout << "last ele:" << dst_v[dst_v.size()-1] << "\n";
    // printf("last ele: %f\n", dst_v[dst_v.size()-9]);
}

int main(int argc, char **argv) {
    engine::kind engine_kind = dnnl::engine::kind::gpu;
    convtest(engine_kind);
}
// clang++ -w t3-sim.cpp -o t3s -lsycl -ldnnl -I/home/wzy/sycl_workspace/oneDNN-cuda/include -I/home/wzy/sycl_workspace/llvm/build-cuda/include/sycl 
// clang++ -w t3-sim.cpp -o t3s -lsycl -ldnnl -I/home/wzy/sycl_workspace/oneDNN-cuda/include -L/home/wzy/sycl_workspace/oneDNN-cuda/lib

