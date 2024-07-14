# game staff
{ config, pkgs, inputs, lib, ... }:

{
    environment.systemPackages = with pkgs; [
        mangoHud
        protonup
        heroic
    ];
    programs = {
        steam = {
            enable = true;
            gamescopeSession = {
                enable = true;
            }
        };
        gamemode = {
            enable = true;
        };
    };
    environment.sessionVariables = { 
        # This is the path where the compatibility tools are installed
        # Remeber to run the protonup command to install the compatibility tools
        STEAM_EXTRA_COMPAT_TOOLS_PATHS =
            "/home/jose/.steam/root/compatibilitytools.d";
    };
}
