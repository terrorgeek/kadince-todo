class TasksController < ApplicationController
  before_action :set_task, only: [:edit, :update, :destroy, :complete]

  def index
    @filter = params[:filter] || 'all'
    @tasks = case @filter
             when 'pending'
               Task.pending
             when 'complete'
               Task.complete
             else
               Task.all.order(created_at: :desc)
             end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.save
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task.update(task_params)
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'Task was successfully deleted.'
  end

  def complete
    @task.complete!
    redirect_to tasks_path, notice: 'Task marked as complete.'
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description)
  end
end