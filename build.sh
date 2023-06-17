#!/bin/bash -eux

source env/bin/activate

if [ ! -d "build" ]; then
  time cmake -G Ninja -B build \
    -DCMAKE_BUILD_TYPE=Release \
    -DPython3_FIND_VIRTUALENV=ONLY \
    -DLLVM_ENABLE_PROJECTS=mlir \
    -DLLVM_EXTERNAL_PROJECTS="torch-mlir;torch-mlir-dialects" \
    -DLLVM_EXTERNAL_TORCH_MLIR_SOURCE_DIR="$PWD" \
    -DLLVM_EXTERNAL_TORCH_MLIR_DIALECTS_SOURCE_DIR="$PWD"/externals/llvm-external-projects/torch-mlir-dialects \
    -DMLIR_ENABLE_BINDINGS_PYTHON=ON \
    -DLLVM_TARGETS_TO_BUILD=host \
    -DLLVM_CCACHE_BUILD=ON \
    -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
    externals/llvm-project/llvm
fi

time ninja -C build

export PYTHONPATH=`pwd`/build/tools/torch-mlir/python_packages/torch_mlir:`pwd`/examples

python examples/torchscript_resnet18_all_output_types.py

