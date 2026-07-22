config: inputs: final: prev:
prev.orca-slicer.overrideAttrs (oldAttrs: {
  postInstall = (oldAttrs.postInstall or "") + ''
    # ensure the existing file ends with a newline before we append
    printf '\n' >> "$out/share/OrcaSlicer/cert/printer.cer"
    cat ${./bambuddy-printer.cer} >> "$out/share/OrcaSlicer/cert/printer.cer"
  '';
})
