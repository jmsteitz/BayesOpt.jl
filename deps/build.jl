using BinDeps

@BinDeps.setup

nlopt = library_dependency("libnlopt")
bayesopt = library_dependency("libbayesopt")
version = v"0.8.2"
commit = "6f2b74381f97"
srcdir = joinpath(BinDeps.depsdir(bayesopt), "src", "rmcantin-bayesopt-$(commit)")
prefix = joinpath(BinDeps.depsdir(bayesopt), "usr")

provides(Sources,
         URI("https://bitbucket.org/rmcantin/bayesopt/downloads/bayesopt-v$version.zip"),
         [nlopt, bayesopt],
         unpacked_dir="rmcantin-bayesopt-$(commit)")

provides(SimpleBuild,
         (@build_steps begin
              GetSources(bayesopt)
              @build_steps begin
                  ChangeDirectory(srcdir)
                  @osx ? `cmake -DCMAKE_INSTALL_PREFIX="$prefix" -DCMAKE_INSTALL_RPATH="$prefix/lib" -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON -DCMAKE_MACOSX_RPATH=ON -DBAYESOPT_BUILD_SHARED=ON -DNLOPT_BUILD_SHARED=ON` : `cmake -DCMAKE_INSTALL_PREFIX="$prefix" -DCMAKE_INSTALL_RPATH="$prefix/lib" -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON -DBAYESOPT_BUILD_SHARED=ON -DNLOPT_BUILD_SHARED=ON`
                  `make`
                  `make install`
              end
          end), [nlopt, bayesopt], os=:Unix)

@BinDeps.install Dict(:libnlopt => :libnlopt, :libbayesopt => :libbayesopt)
