require 'gruff'
class Drawer
  attr_accessor :datasets 

  def setup(datasets)
    @datasets = datasets
  end

  def pie_graph(path, title)
    basic_pie_graph(500, title).write(path)
  end

  def basic_pie_graph(size=500, title)
    g = Gruff::Pie.new(size)
    g.title = title
    g.theme = Gruff::Themes::RAILS_KEYNOTE
    #g.font = 'lib/font.ttf'
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    return g
  end

  def bar_graph(path, labels,title)
    g = Gruff::StackedBar.new
    g.title = title
    g.hide_legend = true
    g.theme = Gruff::Themes::RAILS_KEYNOTE
    g.labels = labels
    @datasets.each do |data|
      g.data(data[0], data[1])
    end
    g.write path
  end
end