{ config, pkgs, lib, ... }:
let
    valuesOfSetToList = set: lib.lists.foldl (prev: package: prev ++ [package.value]) [] (lib.attrsToList set);

    nodePackagesSet = import ./node-packages.nix { pkgs = pkgs; nodejs = pkgs.nodejs_20; };
    nodePackages = valuesOfSetToList nodePackagesSet;
in
{
    home.packages = nodePackages;
}
