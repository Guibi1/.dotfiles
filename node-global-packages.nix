{ config, pkgs, lib, ... }:
let
    valuesOfSetToList = set: lib.lists.foldl (prev: package: prev ++ [package.value]) [] (lib.attrsToList set);

    nodeGlobalPackagesSet = import ./node-global-packages { pkgs = pkgs; nodejs = pkgs.nodejs_20; };
    nodeGlobalPackages = valuesOfSetToList nodeGlobalPackagesSet;
in
{
    home.packages = nodeGlobalPackages;
}
