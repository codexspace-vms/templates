{ pkgs, appName, appId, ... }: {
  packages = [
    pkgs.nodejs_20
  ];
  bootstrap = ''
    mkdir -p "$WS_NAME/. idx"
    
    # Copy the dev.nix configuration
    cp ${./devNix.j2} "$WS_NAME/.idx/dev.nix"
    sed -i "s/{{appName}}/${appName}/g" "$WS_NAME/.idx/dev.nix"
    sed -i "s/{{appId}}/${appId}/g" "$WS_NAME/.idx/dev.nix"
    
    # Copy README
    cp ${./README.j2} "$WS_NAME/README.md"
    
    chmod -R +w "$WS_NAME"
  '';
}