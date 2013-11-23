def text_file_touched
  File.exists? '../hi.ats'
end

def remove_touched_file
  File.delete '../hi.ats'
end