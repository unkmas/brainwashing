require_relative '../rubocop/cop/rails/after_commit_options'
require_relative './rubocop_support.rb'

describe RuboCop::Cop::Rails::AfterCommitOptions do
  let(:config) { RuboCop::Config.new }
  subject(:cop) { described_class.new(config) }

  context 'when one of options defined' do
    it 'does not register offence when :on option defined' do
      expect_no_offenses(<<-RUBY.strip_indent)
        after_commit :do_stuff, on: :create
        after_commit :do_stuff, on: :update
        after_commit :do_stuff, on: :destroy
      RUBY
    end

    it 'does not register offence when :if option defined' do
      expect_no_offenses(<<-RUBY.strip_indent)
        after_commit :do_stuff, if: :should_do_stuff?
      RUBY
    end

    it 'does not register offence when :if option defined' do
      expect_no_offenses(<<-RUBY.strip_indent)
        after_commit :do_stuff, unless: :should_not_do_stuff?
      RUBY
    end

    it 'register offence when all :on variants defined' do
      expect_offense(<<-RUBY.strip_indent)
        after_commit :do_stuff, on: %i[create update destroy]
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Add :if/:unless modifier or limit :on variants
      RUBY
    end
  end

  context 'when multiple options defined' do
    it 'does not register offence' do
      expect_no_offenses(<<-RUBY.strip_indent)
        after_commit :do_stuff, on: :create, if: :should_do_stuff?
      RUBY
    end

    it 'does not register offence when all on variants defined with different option' do
      expect_no_offenses(<<-RUBY.strip_indent)
        after_commit :do_stuff, on: %i[create update destroy], if: :should_do_stuff?
      RUBY
    end
  end

  context 'when no options defined' do
    it 'register offence when no options defined' do
      expect_offense(<<-RUBY.strip_indent)
        after_commit :do_stuff
        ^^^^^^^^^^^^^^^^^^^^^^ Add :on or :if/:unless option
      RUBY
    end
  end
end
