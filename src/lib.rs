use std::ffi::c_void;
use zed_extension_api::{Extension, LanguageServerId, Worktree, Command};

static PLUTO_WASM: &[u8] = include_bytes!("../tree-sitter-pluto.wasm");

pub struct Language {
    name: &'static str,
    wasm_bytes: &'static [u8],
}

impl Language {
    pub fn new(name: &'static str, wasm_bytes: &'static [u8]) -> Self {
        Language { name, wasm_bytes }
    }
}

pub struct LanguageRegistry {
    languages: Vec<Language>,
}

impl LanguageRegistry {
    pub fn new() -> Self {
        LanguageRegistry {
            languages: Vec::new(),
        }
    }

    pub fn register_language(&mut self, language: Language) {
        self.languages.push(language);
    }
}

pub struct PlutoExtension {
    language_registry: LanguageRegistry,
}

impl Extension for PlutoExtension {
    fn new() -> Self {
        let mut registry = LanguageRegistry::new();
        let pluto_language = Language::new("pluto", PLUTO_WASM);
        registry.register_language(pluto_language);
        PlutoExtension {
            language_registry: registry,
        }
    }

    fn language_server_command(&mut self, _config: &LanguageServerId, _worktree: &Worktree) -> Result<Command, String> {
        Err("Not implemented".to_string())
    }
}

#[unsafe(export_name = "init-extension")]
pub extern "C" fn init_extension() {
    // Perform any necessary initialization here
    // For now, just create the extension and leak it to keep it alive
    let _ = Box::leak(Box::new(PlutoExtension::new()));
}
