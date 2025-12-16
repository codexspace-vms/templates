{ pkgs, packageManager ? "npm", ... }: {
  packages = [
    pkgs.nodejs_20
    pkgs.j2cli
    pkgs.nixfmt
  ];
  bootstrap = ''
    mkdir -p "$WS_NAME"
    
    # 1. Create the base Cordova project
    # We use npx to ensure we use a temporary runner without global side effects
    export npm_config_yes=true
    npx cordova create "$WS_NAME" com.example.helloworld HelloWorld
    
    # 2. Enter project directory
    cd "$WS_NAME"
    
    # 3. Initialize package.json to manage dependencies
    npm init -y
    
    # 4. Install Cordova locally so it is available in the workspace
    npm install cordova --save-dev
    
    # 5. Add the Android platform
    npx cordova platform add android
    
    # 6. Generate configuration files using the selected package manager
    mkdir -p .idx
    packageManager=${packageManager} j2 ${./devNix.j2} -o .idx/dev.nix
    packageManager=${packageManager} j2 ${./README.j2} -o README.md
    
    # 7. Final cleanup and move to output
    cd ..
    chmod -R +w "$WS_NAME"
    mv "$WS_NAME" "$out"
  '';
}