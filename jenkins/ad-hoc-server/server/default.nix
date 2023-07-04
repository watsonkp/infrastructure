{ pkgs ? import <nixpkgs> {} }:

pkgs.buildGoModule rec {
	pname = "distribution";
	version = "0.1.0";

	src = ./.;

	vendorHash = null;

	meta = with pkgs.lib; {
		description = "Apple ad hoc distribution compliant server for Jenkins build artifacts.";
		homepage = "https://github.com/watsonkp/distribution";
		license = licenses.mit;
		maintainers = with maintainers; [ watsonkp ];
	};
}
