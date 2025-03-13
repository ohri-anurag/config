-- Formatters for TS, MD and Elm
create_format_on_save("*.ts", function(file)
  return { "prettier", "-w", file }
end)

create_format_on_save("*.json", function(file)
  return { "prettier", "-w", file }
end)

create_format_on_save("*.mjs", function(file)
  return { "prettier", "-w", file }
end)

create_format_on_save("*.md", function(file)
  return { "prettier", "-w", file }
end)

create_format_on_save("*.elm", function(file)
  return { "node_modules/elm-format/bin/elm-format", "--yes", file }
end)
