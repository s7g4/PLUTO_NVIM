use zed_extension_api::{self as zed, Result};

struct PlutoExtension;

impl zed::Extension for PlutoExtension {
    fn new() -> Self {
        Self
    }

    fn language_server_command(
        &mut self,
        _language_server_id: &zed::LanguageServerId,
        _worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        // Pluto doesn't have a language server yet
        Err("No language server available for Pluto".to_string())
    }
}

zed::register_extension!(PlutoExtension);
