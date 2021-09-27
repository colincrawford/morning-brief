require "net/http"
require "set"

require "nokogiri"

module Wikipedia
  class AlgorithmEmail
    def initialize(algorithm)
      @algorithm = algorithm
    end
  end

  class Algorithm
    attr_reader :link, :categories

    def initialize(link:, categories:)
      @link = link
      # a list of category titles (strings) in order from broad to specific
      @categories = categories
    end

    def to_s
      "#{@categories.join("\n")}\nlink: #{@link}\n"
    end
  end

  class AlgorithmsPage
    URL = URI("https://en.wikipedia.org/wiki/List_of_algorithms")

    def initialize
      @algorithms = nil
    end

    def get_random_algorithm
      algorithms.sample
    end

    def algorithms
      if @algorithms.nil?
        @algorithms = fetch_algorithms
      end
      @algorithms
    end

    private

    def fetch_algorithms
      response = Net::HTTP.get(URL)
      parse_wiki_page(response)
    end

    def parse_wiki_page(resp)
      (->(resp) { Nokogiri::HTML.parse(resp) } >>
       ->(tags) { extract_list_of_algo_tags(tags) } >>
       ->(tags) { remove_unwanted_starting_tags(tags) } >>
       ->(tags) { remove_unwanted_trailing_tags(tags) } >>
       ->(tags) { extract_algos(tags) }
      ).call(resp)
    end

    def extract_list_of_algo_tags(page)
      page.css(".mw-parser-output").children
    end

    HEADER_VALS = {"h2" => 2, "h3" => 3, "h4" => 4}
    HEADER_TAGS = ["h2", "h3", "h4"].to_set

    def extract_algos(tags)
      heirarchy = []
      algos = []

      # we have a list of html elements
      # headers sequentially get lower or smaller to indicate category nesting
      # unordered lists (ul tags) have lists of algorithms for the given category
      # there can be nested lists - ie: a list in a list item
      tags.each do |tag|
        # if we hit a header, we just adjust the current category heirarchy
        if HEADER_TAGS.member?(tag.name)
          heirarchy = heirarchy.take_while { |h| HEADER_VALS[tag.name] > HEADER_VALS[h.name] }
          heirarchy << tag
        # we've hit a list of algos, extract those algos
        elsif tag.name == "ul"
          algos = algos.concat(get_algos_from_list(tag, heirarchy))
        end
      end

      algos
    end

    def algo_from_tag_path(tag_path)
      link = get_link(tag_path.last)
      categories = tag_path.map { |tag| get_category_title(tag) }
      Algorithm.new(link: link, categories: categories)
    end

    def get_category_title(category_tag)
      text = if !get_list_child(category_tag).nil?
        category_tag.children.select { |t| t.name != "ul" }.join(" ")
      else
        category_tag.text
      end
      text.gsub("\[edit\]", "").strip
    end

    def get_link(algo_tag)
      link = algo_tag.children.find { |el| el.name == "a" }
      if link.nil?
        "No Link Found"
      else
        "https://en.wikipedia.org#{link.attributes["href"]}"
      end
    end

    def get_list_child(tag)
      tag.children.find { |el| el.name == "ul" }
    end

    def get_list_items(ul)
      ul.children.select { |child| child.name == "li" }
    end

    def get_tag_id(tag)
      id = tag.attributes["id"]
      return nil if id.nil?
      id.value
    end

    def get_algos_from_list(ul, heirarchy)
      get_list_items(ul).flat_map do |child|
        # look for a nested list
        nested_list = get_list_child(child)
        if nested_list.nil?
          [algo_from_tag_path([*heirarchy, child])]
        else
          get_algos_from_list(nested_list, [*heirarchy, child])
        end
      end
    end

    def remove_unwanted_trailing_tags(tags)
      tags.take_while { |tag| !(tag.name == "h2" && tag.text == "See also[edit]") }
    end

    def remove_unwanted_starting_tags(tags)
      toc_inx = tags.find_index { |tag| get_tag_id(tag) == "toc" }
      raise "Couldn't find the table of contents tag" if toc_inx.nil?
      tags.drop(toc_inx + 1)
    end
  end
end
