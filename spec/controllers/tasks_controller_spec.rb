require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe 'GET #index' do
    context 'when no filter is applied' do
      it 'assigns all tasks ordered by created_at desc to @tasks' do
        task1 = Task.create!(title: 'Task 1', description: 'Description 1')
        task2 = Task.create!(title: 'Task 2', description: 'Description 2')
        get :index
        expect(assigns(:tasks)).to eq([task2, task1])
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context 'when filtering by pending tasks' do
      it 'assigns only pending tasks to @tasks' do
        pending_task = Task.create!(title: 'Pending Task', description: 'Pending Description', status: :pending)
        completed_task = Task.create!(title: 'Completed Task', description: 'Completed Description', status: :complete)
        get :index, params: { filter: 'pending' }
        expect(assigns(:tasks)).to eq([pending_task])
      end
    end

    context 'when filtering by complete tasks' do
      it 'assigns only complete tasks to @tasks' do
        pending_task = Task.create!(title: 'Pending Task', description: 'Pending Description', status: :pending)
        completed_task = Task.create!(title: 'Completed Task', description: 'Completed Description', status: :complete)
        get :index, params: { filter: 'complete' }
        expect(assigns(:tasks)).to eq([completed_task])
      end
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:valid_attributes) { { task: { title: 'New Task', description: 'New Description' } } }

      it 'creates a new task' do
        expect {
          post :create, params: valid_attributes, xhr: true
        }.to change(Task, :count).by(1)
      end

      it 'responds with HTTP status 200' do
        post :create, params: valid_attributes, xhr: true
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { { task: { title: nil, description: 'New Description' } } }

      it 'does not create a new task' do
        expect {
          post :create, params: invalid_attributes, xhr: true
        }.to_not change(Task, :count)
      end
    end
  end

  describe 'GET #edit' do
    let(:task) { Task.create!(title: 'Edit Task', description: 'Edit Description') }

    it 'assigns the requested task to @task' do
      get :edit, params: { id: task.id }, xhr: true
      expect(assigns(:task)).to eq(task)
    end
  end

  describe 'PATCH #update' do
    let(:task) { Task.create!(title: 'Original Title', description: 'Original Description') }

    context 'with valid attributes' do
      let(:valid_attributes) { { id: task.id, task: { title: 'Updated Title', description: 'Updated Description' } } }

      it 'updates the task' do
        patch :update, params: valid_attributes, xhr: true
        task.reload
        expect(task.title).to eq('Updated Title')
        expect(task.description).to eq('Updated Description')
      end

      it 'should have http status ok' do
        patch :update, params: valid_attributes, xhr: true
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { { id: task.id, task: { title: nil, description: 'Updated Description' } } }

      it 'does not update the task' do
        patch :update, params: invalid_attributes, xhr: true
        task.reload
        expect(task.title).to eq('Original Title')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:task) { Task.create!(title: 'Task to Delete', description: 'Description to Delete') }

    it 'destroys the task' do
      expect {
        delete :destroy, params: { id: task.id }
      }.to change(Task, :count).by(-1)
    end

    it 'redirects to the tasks index path with a notice' do
      delete :destroy, params: { id: task.id }
      expect(response).to redirect_to(tasks_path)
      expect(flash[:notice]).to eq('Task was successfully deleted.')
    end
  end

  describe 'PATCH #complete' do
    let(:task) { Task.create!(title: 'Incomplete Task', description: 'Incomplete Description', status: :pending) }

    it 'marks the task as complete' do
      patch :complete, params: { id: task.id }
      task.reload
      expect(task.status).to eq('complete')
    end

    it 'redirects to the tasks index path with a notice' do
      patch :complete, params: { id: task.id }
      expect(response).to redirect_to(tasks_path)
      expect(flash[:notice]).to eq('Task marked as complete.')
    end
  end
end