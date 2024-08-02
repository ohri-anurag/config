-- Fomatters for haskell and cabal files
create_format_on_save("*.cabal", function(file)
  return { "cabal-fmt", "--inplace", file }
end)

create_format_on_save("*.hs", function(file)
  return { "ormolu", "-i", file }
end)
