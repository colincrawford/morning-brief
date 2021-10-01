class AppEmail
  def initialize(leetcode_problem:, wikipedia_algo:, todos:)
    @leetcode_problem = leetcode_problem
    @wikipedia_algo = wikipedia_algo
    @todos = todos
  end

  def html
    wikipedia_page = "https://en.wikipedia.org/wiki/List_of_algorithms"
    categories = @wikipedia_algo.categories.map { |category|
      "<p>#{category}</p>"
    }
    last = categories[categories.size - 1]
    tag = "<a href=\"#{@wikipedia_algo.link}\">#{last}</a>"
    categories[categories.size - 1] = tag

    todo_list = @todos.map do |todo|
      "<li><del>#{todo.description}</del></li>" if todo.done
      "<li>#{todo.description}</li>"
    end

    <<~HTML
      <h2>Here is your Leetcode problem!</h2>
      <br/>
      <p>Difficulty: <em>#{@leetcode_problem.difficulty}</em></p>
      <a href=#{@leetcode_problem.link}>#{@leetcode_problem.title}</a>
      <hr/>
      <a href="#{wikipedia_page}">
        <h2>An Algorithm From Wikipedia</h2>
      </a>
      <br/>
      #{categories.join}
      <br/>
      <section>
        <h2>Todos</h2>
        <ul>
          #{todo_list.join}
        </ul>
      </section>
    HTML
  end
end
