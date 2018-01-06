class Someclass
  after_commit :do_stuff, on: %i[foo bar], if: :fhjd
end