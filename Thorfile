$:.unshift(File.dirname(__FILE__) + "_plugins")
class Jah < Thor
  include Thor::Actions

  desc "haml", "Render haml layout files to html"
  def haml
    system (%{
      cd _layouts/haml && for f in *.haml; do [ -e $f ] && haml $f ../${f%.haml}.html; done
    })
    puts "done"
  end
 
  desc "preview", "Compile site and watch for changes"
  def preview( watch = "")
    invoke :haml
    system (%{
      jekyll && compass compile --force
    })
  end

  desc "watch", "watch for css changes"
  def watch
    system(%{
      compass watch
    })
  end
end
