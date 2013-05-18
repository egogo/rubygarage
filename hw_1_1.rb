class Library
  def initialize
    @orders = []
  end

  def add(order)
    raise ArgumentError unless order.instance_of?(BookOrder)
    @orders << order
  end

  def order_count
    @orders.count
  end

  def shortest_lookup
    @orders.map(&:lookup_duration).min
  end

  def not_satisfied_orders
    @orders.reject(&:satisfied?)
  end

  def top_lenders_for(book, max = 3)
    @orders.select {|o| o.book_title == book && o.satisfied? }
    .inject(Hash.new(0)){|m,o| m[o.lender_name] += 1; m }
    .sort_by {|_,v| v}.reverse[0...max].map(&:first)
  end

  def most_popular_books(limit = 1)
    @orders.inject(Hash.new(0)) {|m, o| m[o.book_title] += 1; m }
    .sort_by {|_,v| v}.reverse[0...limit].map(&:first)
  end

  def number_of_people_ordered_one_of_the_three_most_popular_books
    books = most_popular_books(3)
    @orders.select {|o| books.include?(o.book_title) }
    .inject(Hash.new {|h,k| h[k] = [] }) do |m,o|
      m[o.lender_name] << o.book_title
      m[o.lender_name].uniq!
      m
    end.inject(0) {|s,(_,v)| s += (v.size == 1 ? 1 : 0) }
  end
end

class BookOrder
  attr_accessor :book_title, :lender_name, :order_date, :issue_date

  def initialize(book_title, lender_name, order_date = Time.now, issue_date = nil)
    @book_title, @lender_name, @order_date, @issue_date = book_title, lender_name, order_date, issue_date
  end

  def lookup_duration
    @issue_date ? (@issue_date - @order_date).round : Float::INFINITY
  end

  def satisfied?
    !@issue_date.nil?
  end
end
