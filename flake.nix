{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    dream2nix = {
      url = "github:davhau/dream2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, dream2nix }@inputs:
    let
      # Generate a user-friendly version number.
      version = builtins.substring 0 8 self.lastModifiedDate;

      # System types to support.
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; overlays = [ self.overlay ]; });

      dream2nix = inputs.dream2nix.lib.init {
        systems = supportedSystems;
        config = {
          overridesDirs = [
            "${inputs.dream2nix}/overrides"
            ./dream2nix-overrides
          ];
        };
      };
    in
    {
      overlay = final: prev: { };

      packages = forAllSystems (system: {
        monitoror_core = nixpkgsFor.${system}.buildGoModule {
          name = "monitoror";
          src = ./.;
          vendorSha256 = "sha256-dPWyui1v3AQNOKfzvY9l8PLoUah7kJxmyw/fO1rpIBk=";
        };
        monitoror_ui = (dream2nix.riseAndShine {
          source = ./ui;
        }).defaultPackage.${system};
      });
    };
}
