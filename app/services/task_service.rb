class TaskService
  
  def self.send_task_result(task_id, status, scraped_data)
    begin
      response = RestClient.post("#{ENV['TASK_MANAGER_URL']}/api/v1/tasks/update",
      {
        task_id: task_id,
        task_status: status,
        task_result: scraped_data.present? ? { brand: scraped_data[:brand], model: scraped_data[:model], price: scraped_data[:price] } : nil
      }.to_json,
        { content_type: :json, accept: :json }
      )
      message = JSON.parse(response.body)['message']
      Rails.logger.info("Resposta do task-manager: #{message}")
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error("Erro ao enviar resultado da tarefa: #{e.response}")
    end
  end

end