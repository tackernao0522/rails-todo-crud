titles = %w(test1 test2 test3 test4 test5)
0.upto(4) do |idx|
  Todo.create(
    title: titles[idx],
    comment: "test-#{titles[idx]}",
    limit: "2022-12-24"
  )
end
