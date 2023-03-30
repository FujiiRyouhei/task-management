require "rails_helper"

RSpec.describe Task, type: :model do
  context "title を指定している時" do
    it "task が作られる" do
      task = Task.new(title: "foo", completed: "false")
      expect(task.valid?).to eq true
    end
  end

  context "title を指定していない時" do
    it "task の作成に失敗する" do
      task = Task.new(title: nil, completed: "false")
      expect(task).to be_invalid
      expect(task.errors.details[:title][0][:error]).to eq :blank
      # binding.pry
    end
  end

  context "completed を指定していない時" do
    it "デフォルトの false の値が参照される" do
      task = Task.new(title: "foo")
      expect(task).to be_valid
      expect(task.completed).to eq false
      # binding.pry
    end
  end
end
