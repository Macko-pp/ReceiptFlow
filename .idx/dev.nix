{pkgs}: {
  channel = "stable-23.11";
  packages = [
    pkgs.nodejs_20
  ];
  idx.extensions = [
    "svelte.svelte-vscode"
    "vue.volar"
    "akamud.vscode-theme-onedark"
    "akamud.vscode-theme-onelight"
    "alefragnani.project-manager"
    "artdiniz.quitcontrol-vscode"
    "bradlc.vscode-tailwindcss"
    "christian-kohler.npm-intellisense"
    "christian-kohler.path-intellisense"
    "csstools.postcss"
    "esbenp.prettier-vscode"
    "file-icons.file-icons"
    "formulahendry.auto-close-tag"
    "GitHub.vscode-pull-request-github"
    "idleberg.applescript"
    "miguelsolorio.fluent-icons"
    "ms-python.autopep8"
    "ms-python.debugpy"
    "ms-python.python"
    "ms-vscode.atom-keybindings"
    "NativeScript.nativescript"
    "naumovs.color-highlight"
    "PKief.material-icon-theme"
    "shyykoserhiy.vscode-spotify"
    "vitest.explorer"
    "vivaxy.vscode-conventional-commits"
    "yzhang.markdown-all-in-one"
  ];
  idx.previews = {
    previews = {
      web = {
        command = [
          "npm"
          "run"
          "dev"
          "--"
          "--port"
          "$PORT"
          "--host"
          "0.0.0.0"
        ];
        manager = "web";
      };
    };
  };
}