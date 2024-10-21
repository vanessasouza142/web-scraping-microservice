class NotificationService
  
  def self.send_notification(task_id, task_url, status, action_done_by_user)
    begin
      response = RestClient.post("#{ENV['NOTIFICATION_SERVICE_URL']}/api/v1/notification",
        {
          task_id: task_id,
          task_url: task_url,
          task_status: status,
          action: 'scraping',
          action_done_by_user: action_done_by_user
        }.to_json,
        { content_type: :json, accept: :json }
      )
      message = JSON.parse(response.body)['message']
      Rails.logger.info("Resposta do microserviço de notificações: #{message}")
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error("Erro ao enviar notificação: #{e.response}")
    end
  end

end