{ lib, config, user, ... }:
let
  cfg = config.modules.desktop.dev.rust;
in {
  home-manager.users.${user}.programs.nixvim.plugins.lsp.servers.rust_analyzer = lib.mkIf cfg.enable {
    enable = true;

    installCargo = false;
    installRustc = false;

    settings.check.overrideCommand = [
      "cargo"
      "clippy"

      "--workspace"
      "--message-format=json"

      "--all-targets"
      "--all-features"

      "--"

      # Warnings
      "-Wclippy::pedantic"
      "-Wclippy::nursery"
      "-Wclippy::create_dir"
      "-Wclippy::empty_structs_with_brackets"
      "-Wclippy::filetype_is_file"
      "-Wclippy::get_unwrap"
      "-Wclippy::indexing_slicing"
      "-Wclippy::impl_trait_in_params"
      "-Wclippy::lossy_float_literal"
      "-Wclippy::str_to_string"
      "-Wclippy::string_add"
      "-Wclippy::string_to_string"
      "-Wclippy::suspicious_xor_used_as_pow"
      "-Wclippy::unneeded_field_pattern"
      "-Wclippy::unnecessary_self_imports"
      "-Wclippy::unseparated_literal_suffix"
      "-Wclippy::todo"

      # Allows
      "-Aclippy::missing_errors_doc"
      "-Aclippy::missing_panics_doc"
      "-Aclippy::must_use_candidate"
    ];
  };
}
