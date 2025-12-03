# MMDT XDMA

# To see the contents inside the buffer, which is printed byte by byte, set printData variable to True
```
int main(int argc, char *argv[]) {
    bool printData = true;
    SingleLineMMDT singleLineMMDT;
}
```

# Below provided are examples of how to use the provided functionality to do memory mapped data transfer



## 1. Writing an array of uint64_t data to FPGA using /dev/xdma0_h2c_0
```
int main(int argc, char *argv[]) {
    uint64_t address = 1073741824;
    
    SingleLineMMDT singleLineMMDT;

    typedef uint64_t dataType;

    // Vector of data, update the data according to data type
    std::vector<dataType> data = {1,2,3,4,5,6,7,8,9};

    std::cout << "Array data: ";
    dmaUtils.printArray(data);

    int rc = singleLineMMDT.sendToFPGA(data, 7, address, DEVICE_NAME_WRITE);
    if (rc < 0) {
        std::cerr << "sendToFPGA failed.\n";
        return EXIT_FAILURE;
    }
    std::vector<dataType> outData;
    rc = singleLineMMDT.readFromFPGA(outData, 4, address, DEVICE_NAME_READ);
    if (rc < 0) {
        std::cerr << "readFromFPGA failed.\n";
        return EXIT_FAILURE;
    }

    std::cout << "Output data: ";
    dmaUtils.printArray(outData);
    return 0;
}
```



## 2. Writing text data to FPGA using /dev/xdma0_h2c_0
```
int main(int argc, char *argv[]) {
    uint64_t address = 1073741824;
    
    SingleLineMMDT singleLineMMDT;

    std::string data = "This is a test string";
    std::cout << "Text: " << data <<std::endl;

    int rc = singleLineMMDT.sendToFPGA(data, data.length(), address, DEVICE_NAME_WRITE);
    if (rc < 0) {
        std::cerr << "sendToFPGA failed.\n";
        return EXIT_FAILURE;
    }
    std::string outData;
    rc = singleLineMMDT.readFromFPGA(outData, 15, address, DEVICE_NAME_READ);
    if (rc < 0) {
        std::cerr << "readFromFPGA failed.\n";
        return EXIT_FAILURE;
    }

    std::cout << "Output data: " << outData << std::endl;
    return 0;
}
```


## 3. Writing an array of uint64_t data to FPGA using all available h2c channels
```
int main(int argc, char *argv[]) {
    uint64_t address = 1073741824;
    
    ParallelMMDT parallelMMDT;

    typedef uint64_t dataType;

    // Vector of data, update the data according to data type
    std::vector<dataType> data = {1,2,3,4,5,6,7,8,9};

    std::cout << "Array data: ";
    dmaUtils.printArray(data);

    int rc = parallelMMDT.sendToFPGA(data, 7, address);
    if (rc < 0) {
        std::cerr << "sendToFPGA failed.\n";
        return EXIT_FAILURE;
    }
    std::vector<dataType> outData;
    rc = parallelMMDT.readFromFPGA(outData, 5, address);
    if (rc < 0) {
        std::cerr << "readFromFPGA failed.\n";
        return EXIT_FAILURE;
    }

    std::cout << "Output data: ";
    dmaUtils.printArray(outData);
    return 0;
}
```



## 4. Writing text data to FPGA using all available h2c channels
```
int main(int argc, char *argv[]) {
    uint64_t address = 1073741824;
    
    ParallelMMDT parallelMMDT;

    std::string data = "This is a test string";
    std::cout << "Text: " << data <<std::endl;

    int rc = parallelMMDT.sendToFPGA(data, 21, address);
    if (rc < 0) {
        std::cerr << "sendToFPGA failed.\n";
        return EXIT_FAILURE;
    }
    std::string outData;
    rc = parallelMMDT.readFromFPGA(outData, 20, address);
    if (rc < 0) {
        std::cerr << "readFromFPGA failed.\n";
        return EXIT_FAILURE;
    }

    std::cout << "Output data: " << outData << std::endl;
    return 0;
}
```