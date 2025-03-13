-- Fomatters for nix files
create_format_on_save("*.nix", function(file)
  return { "nixfmt", file }
end)
