require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it 'is valid with a title and description' do
      task = Task.new(title: 'Valid Title', description: 'Valid Description')
      expect(task).to be_valid
    end

    it 'is invalid without a title' do
      task = Task.new(description: 'Valid Description')
      expect(task).to be_invalid
      expect(task.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without a description' do
      task = Task.new(title: 'Valid Title')
      expect(task).to be_invalid
      expect(task.errors[:description]).to include("can't be blank")
    end
  end

  describe 'enums' do
    it 'defines the status enum with pending and complete values' do
      expect(Task.statuses).to eq({'pending' => 0, 'complete' => 1})
      expect(Task.new(status: :pending)).to be_pending
      expect(Task.new(status: :complete)).to be_complete
    end
  end

  describe 'scopes' do
    describe '.pending' do
      it 'returns only pending tasks' do
        pending_task = Task.create!(title: 'Pending Task', description: 'Pending Description', status: :pending)
        completed_task = Task.create!(title: 'Completed Task', description: 'Completed Description', status: :complete)
        expect(Task.pending).to eq([pending_task])
      end
    end

    describe '.complete' do
      it 'returns only complete tasks' do
        pending_task = Task.create!(title: 'Pending Task', description: 'Pending Description', status: :pending)
        completed_task = Task.create!(title: 'Completed Task', description: 'Completed Description', status: :complete)
        expect(Task.complete).to eq([completed_task])
      end
    end
  end

  describe '#complete!' do
    let(:task) { Task.create!(title: 'Initial Task', description: 'Initial Description', status: :pending) }

    it 'changes the task status to complete' do
      task.complete!
      expect(task.status).to eq('complete')
    end
  end
end