config: inputs: final: prev:
# thanks https://r.je/evict-your-darlings
# avoid .mozilla folder in ~/
prev.firefox.overrideAttrs (oldAttrs: {
  buildCommand =
    oldAttrs.buildCommand
    + ''
      wrapProgram "$executablePath" \
        --set 'HOME' '${config.user-config.home}/.config/mozilla'
    '';
})
