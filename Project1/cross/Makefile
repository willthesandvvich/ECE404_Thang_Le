# Install location
INSTALL_DIR=$(shell pwd)
export PATH:=$(INSTALL_DIR)/bin:$(PATH)

.PHONY: install

install: $(INSTALL_DIR)/bin/clang
	rm -rf $(CMAKE) $(CMAKE_BUILD)
	rm -rf $(LLVM) $(LLVM_BUILD)

# LLVM
LLVM_VERSION=4.0.0
LLVM=llvm-$(LLVM_VERSION).src
LLVM_TAR=$(LLVM).tar.xz
LLVM_BUILD=llvm-build

.INTERMEDIATE: $(LLVM_TAR)

$(INSTALL_DIR)/bin/clang: $(LLVM_BUILD)/bin/clang
	cd $(LLVM_BUILD) && cmake --build . --target install

$(LLVM_BUILD)/bin/clang: $(LLVM_BUILD)/Makefile
	cd $(LLVM_BUILD) && $(MAKE)

$(LLVM_BUILD)/Makefile: $(LLVM_BUILD) $(LLVM) $(INSTALL_DIR)/bin/cmake clang
	cd $(LLVM_BUILD) && cmake ../$(LLVM)/ -DCMAKE_INSTALL_PREFIX=$(INSTALL_DIR) -DLLVM_ENABLE_PROJECTS="clang" -DLLVM_TARGETS_TO_BUILD="Mips" -G "Unix Makefiles"

clang: $(LLVM)
	@echo wget http://releases.llvm.org/4.0.0/cfe-4.0.0.src.tar.xz
	wget --quiet http://releases.llvm.org/4.0.0/cfe-4.0.0.src.tar.xz
	tar xJf cfe-4.0.0.src.tar.xz
	mv cfe-4.0.0.src clang
	rm cfe-4.0.0.src.tar.xz

$(LLVM_BUILD):
	mkdir $@

$(LLVM): $(LLVM_TAR)
	tar xJf $<

$(LLVM_TAR):
	@echo wget http://releases.llvm.org/$(LLVM_VERSION)/$@
	wget --quiet http://releases.llvm.org/$(LLVM_VERSION)/$@

# CMake is needed to build clang
CMAKE=cmake-3.7.2
CMAKE_TAR=$(CMAKE).tar.gz
CMAKE_BUILD=cmake-build

.INTERMEDIATE: $(CMAKE_TAR)

$(INSTALL_DIR)/bin/cmake: $(CMAKE_BUILD)/bin/cmake
	cd $(CMAKE_BUILD) && $(MAKE) install

$(CMAKE_BUILD)/bin/cmake: $(CMAKE_BUILD)/Makefile
	cd $(CMAKE_BUILD) && $(MAKE)

$(CMAKE_BUILD)/Makefile: $(CMAKE_BUILD) $(CMAKE)
	cd $(CMAKE_BUILD) && ../$(CMAKE)/bootstrap --prefix=$(INSTALL_DIR)

$(CMAKE_BUILD):
	mkdir $@

$(CMAKE): $(CMAKE_TAR)
	tar xzf $<

$(CMAKE_TAR):
	@echo wget https://cmake.org/files/v3.7/$(CMAKE_TAR)
	wget --quiet https://cmake.org/files/v3.7/$(CMAKE_TAR)

