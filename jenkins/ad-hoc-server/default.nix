let
	pkgs = import <nixpkgs> { };
	server = pkgs.callPackage ./server/default.nix { };
	container = server:
		pkgs.dockerTools.buildImage {
			name = "sulliedeclat/distribution";
			tag = "latest";
			copyToRoot = [ server ];
			config = {
				Cmd = [ "/bin/distribution" ];
				Volumes = {
					"/data/" = {};
					"/static/" = {};
				};
			};
		};
in container server
