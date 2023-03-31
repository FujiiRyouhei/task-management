require "rails_helper"

RSpec.describe "Tasks", type: :request do
  describe "GET /tasks" do
    subject { get(tasks_path) }

    before { create_list(:task, 3) }

    it "task の一覧を取得できる" do
      # binding.pry
      subject
      res = JSON.parse(response.body)
      expect(res.length).to eq 3
      expect(res[0].keys).to eq ["id", "title", "description", "due_date", "completed", "created_at", "updated_at", "url"]
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /tasks/:id" do
    subject { get(task_path(task_id)) }

    context "指定した id の task が存在する時" do
      let(:task_id) { task.id }
      let(:task) { create(:task) }

      it "その task の詳細が取得できる" do
        # binding.pry
        subject
        res = JSON.parse(response.body)
        expect(res["title"]).to eq task.title
        expect(res["description"]).to eq task.description
        expect(res["due_date"]).to eq task.due_date.strftime
        expect(res["completed"]).to eq task.completed
        expect(response).to have_http_status(:ok)
      end
    end

    context "指定した id の task が存在しない時" do
      let(:task_id) { 1_000_000_000 }

      it "task が見つからない" do
        # binding.pry
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "POST /tasks" do
    subject { post(tasks_path, params: params) }

    context "適切なパラメーターを送信したとき" do
      let(:params) { { task: attributes_for(:task) } }

      it "task が作成される" do
        expect { subject }.to change { Task.count }.by(1)
        res = JSON.parse(response.body)
        expect(res["title"]).to eq params[:task][:title]
        expect(res["description"]).to eq params[:task][:description]
        expect(res["due_date"]).to eq params[:task][:due_date].strftime
        expect(res["completed"]).to eq params[:task][:completed]
        expect(response).to have_http_status(:created)
      end
    end

    context "不適切なパラメーターを送信した時" do
      context "user キーにパラメーターを入れていない時" do
        let(:params) { attributes_for(:task) }

        it "task の作成に失敗する" do
          expect { subject }.to raise_error(ActionController::ParameterMissing)
        end
      end
    end
  end

  describe "PATCH /tasks/:id" do
    subject { patch(task_path(task_id), params: params) }

    let(:params) do
      { task: { title: Faker::String.random(length: 4), created_at: 1.days.ago } }
    end
    let(:task_id) { task.id }
    let(:task) { create(:task) }

    it "任意の task の内容が更新できる" do
      expect { subject }.to change { Task.find(task_id).title }.from(task.title).to(params[:task][:title]) &
                            not_change { Task.find(task_id).description }
      not_change { Task.find(task_id).due_date }
      not_change { Task.find(task_id).completed }
    end
  end

  describe "DELETE /tasks/:id" do
    subject { delete(task_path(task_id)) }

    let(:task_id) { task.id }
    let!(:task) { create(:task) }

    it "指定した id の taskが削除される " do
      expect { subject }.to change { Task.count }.by(-1)
    end
  end
end
