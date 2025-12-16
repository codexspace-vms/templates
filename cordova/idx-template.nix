{ pkgs, packageManager ? "npm", ... }: {
  packages = [
    pkgs.nodejs_20
    pkgs.yarn
    pkgs. j2cli
    pkgs.nixfmt
  ];
  bootstrap = ''
    mkdir -p "$WS_NAME"
    npm install -g cordova
    cordova create "$WS_NAME" com.example.app MyApp
    cd "$WS_NAME"
    cordova platform add android
    cordova platform add browser
    mkdir "$WS_NAME/.idx/"
    packageManager=${packageManager} j2 ${./devNix. j2} -o "$WS_NAME/.idx/dev.nix"
    packageManager=${packageManager} j2 ${./README.j2} -o "$WS_NAME/README.md"
    chmod -R +w "$WS_NAME"
    mv "$WS_NAME" "$out"
  '';
}