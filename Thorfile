class Jah < Thor
  include Thor::Actions

  desc "haml", "Render haml layout files to html"
  def haml
    system (%{
      cd _layouts/haml && for f in *.haml; do [ -e $f ] && haml $f ../${f%.haml}.html; done
    })
    puts "done"
  end
end
