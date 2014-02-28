# Don't print something if we already have..
$write_count = 0
def STDOUT.write(what)
   $write_count += 1
   super(what)
end

# execute the code
begin
  r = eval(ARGV[0])
rescue Object
  r = $!.class.to_s
end

# try to_s, if it doesn't work use inspect
# Array and Hash are shown via inspect because they look better with formatting
# do this just if the script did not print anything itself
if $write_count == 0
  print( (r.class != Hash and r.class != Array and not r.nil? and r.respond_to? :to_s) ? r.to_s : r.inspect )
end
