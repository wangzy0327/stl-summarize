#include <CL/sycl.hpp>

void show_platforms() {
  auto platforms = sycl::platform::get_platforms();

  for (auto &platform : platforms) {
    std::cout << "Platform: "
	      << platform.get_info<sycl::info::platform::name>()
	      << std::endl;

    auto devices = platform.get_devices();
    for (auto &device : devices ) {
      std::cout << "  Device: "
		<< device.get_info<sycl::info::device::name>()
		<< std::endl;
    }
  }
}

int main() {

  show_platforms();
  // auto name = sycl::info::platform::name;
  // auto con = cl::sycl::context();
  // auto properties = cl::sycl::property_list();
  // Creating buffer of 4 ints to be used inside the kernel code
  cl::sycl::buffer<cl::sycl::cl_int, 1> Buffer(4);

  //sycl::gpu_selector s;

  // Creating SYCL queue
  cl::sycl::queue Queue;
  //cl::sycl::queue Queue();

  auto dev = Queue.get_device();
  std::cout<<"================================"<<std::endl;
  std::cout << "Default Device: "
		<< dev.get_info<sycl::info::device::name>()
		<< std::endl;

  // Size of index space for kernel
  cl::sycl::range<1> NumOfWorkItems{Buffer.size()};

  // Submitting command group(work) to queue
  Queue.submit([&](cl::sycl::handler &cgh) {
    // Getting write only access to the buffer on a device
    auto Accessor = Buffer.get_access<cl::sycl::access::mode::write>(cgh);
    // auto out = sycl::stream(1024, 768, cgh);
    // auto task = [=]() { out << "In a task\n"; };
    // Executing kernel
    cgh.parallel_for<class FillBuffer>(
        NumOfWorkItems, [=](cl::sycl::id<1> WIid) {
          // out<<"parallel for before\n";
          // Fill buffer with indexes
          Accessor[WIid] = (cl::sycl::cl_int)WIid.get(0);
        });
    // cgh.single_task<class stream_task>(task);
  });

  // Getting read only access to the buffer on the host.
  // Implicit barrier waiting for queue to complete the work.
  const auto HostAccessor = Buffer.get_access<cl::sycl::access::mode::read>();

  // Check the results
  bool MismatchFound = false;
  for (size_t I = 0; I < Buffer.size(); ++I) {
    if (HostAccessor[I] != I) {
      std::cout << "The result is incorrect for element: " << I
                << " , expected: " << I << " , got: " << HostAccessor[I]
                << std::endl;
      MismatchFound = true;
    }
  }

  if (!MismatchFound) {
    std::cout << "The results are correct!" << std::endl;
  }

  return MismatchFound;
}
