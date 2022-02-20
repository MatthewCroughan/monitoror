{
  lib,
  pkgs,
  # dream2nix
  satisfiesSemver,
  ...
}:
let
  esbuildBinary = pkgs.buildGoModule rec {
    pname = "esbuild";
    version = "0.6.34";

    src = pkgs.fetchFromGitHub {
      owner = "evanw";
      repo = "esbuild";
      rev = "v${version}";
      sha256 = "sha256-MYjhukbpYrLRj+PgslTGfZXPhMt/IZ6JQG3JXwicZJY=";
    };
    vendorSha256 = "sha256-dj0bqQ4uKHu1aKwqGG3LB6puxhYrfvvcb58rVNb5RQw=";
  };
in
{
  esbuild.build = {
#    buildInputs = with pkgs; [ nodePackages.npm python3 jq nodejs ];
#    ESBUILD_BINARY_PATH = "${esbuildBinary}/bin";
    preBuild = ''
      echo $ESBUILD_BINARY_PATH
      echo $ESBUILD_BINARY_PATH
      echo $ESBUILD_BINARY_PATH
      echo $ESBUILD_BINARY_PATH
      echo $ESBUILD_BINARY_PATH
      echo $ESBUILD_BINARY_PATH
      echo $ESBUILD_BINARY_PATH
      echo $ESBUILD_BINARY_PATH
      echo $ESBUILD_BINARY_PATH
    '';
  };
  esbuild.add-binary.ESBUILD_BINARY_PATH = "${esbuildBinary}/bin/esbuild";
  monitoror-unknown.build = {
    nativeBuildInputs = [ pkgs.esbuild ];
    preBuild = '' export ESBUILD_BINARY_PATH = "${esbuildBinary}/bin/esbuild"'';
  };
}
