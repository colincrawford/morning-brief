class AppEmail
  def initialize(leetcode_problem:, wikipedia_algo:)
    @leetcode_problem = leetcode_problem
    @wikipedia_algo = wikipedia_algo
  end

  def html
    categories = @wikipedia_algo.categories.map { |category|
      "<p>#{category}</p>"
    }
    last = categories[categories.size - 1]
    tag = "<a href=\"#{@wikipedia_algo.link}\">#{last}</a>"
    categories[categories.size - 1] = tag

    <<~HTML
      <h2>Here is your Leetcode problem!</h2>
      <br>
      <p>Difficulty: <em>#{@leetcode_problem.difficulty}</em></p>
      <a href=#{@leetcode_problem.link}>#{@leetcode_problem.title}</a>
      <hr>
      <a href="#{Wikipedia::AlgorithmsPage::URL}">
        <h2>An Algorithm From Wikipedia</h2>
      </a>
      <br>
      #{categories.join}
    HTML
  end
end
