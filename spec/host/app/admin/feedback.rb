# spec/host/app/admin/feedback.rb
# frozen_string_literal: true

ActiveAdmin.register_page "Feedback" do
  controller do
    before_action do
      flash.now[:notice] = "Synthetic notice: changes saved."
      flash.now[:alert] = "Synthetic warning: review before continuing."
      flash.now[:error] = "Synthetic error: operation was not completed."
    end
  end

  content do
    panel "Status Vocabulary" do
      para "Statuses retain their words; the theme does not assign domain meaning."
      [true, false, nil, "Waiting On Operator", "REFERENCE-" * 20].each { |status| status_tag status }
    end
    panel "Utility Isolation" do
      para "This host-owned green utility is not a flash.", class: "bg-green-50 text-green-950"
    end
  end
end
