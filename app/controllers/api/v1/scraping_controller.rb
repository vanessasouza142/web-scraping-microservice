class Api::V1::ScrapingController < ApplicationController

  def create
    task_id = params[:task_id]
    task_url = params[:task_url]
    action_done_by_user = params[:action_done_by_user]

    begin
      scraped_data = ScrapingService.scrape_data(task_url)

      if scraped_data[:brand].present? && scraped_data[:model].present? && scraped_data[:price].present?
        ScrapedData.create!(task_id: task_id, task_url: task_url, brand: scraped_data[:brand], model: scraped_data[:model], price: scraped_data[:price])
        NotificationService.send_notification(task_id, task_url, 'completed', action_done_by_user)
        TaskService.send_task_result(task_id, 'completed', scraped_data)
        render json: { message: 'Web scraping concluído com sucesso!', Resultado: scraped_data }, status: :ok
      else
        NotificationService.send_notification(task_id, task_url, 'failure', action_done_by_user)
        TaskService.send_task_result(task_id, 'failure', nil)
        render json: { error: 'Falha ao coletar os dados.' }, status: :unprocessable_entity
      end
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error("Erro ao acessar a URL: #{e.message}")
      render json: { error: 'Erro ao acessar a URL.' }, status: :unprocessable_entity
    rescue => e
      Rails.logger.error("Erro durante o scraping: #{e.message}")
      render json: { error: 'Erro ao realizar o scraping.' }, status: :unprocessable_entity
    end
  end

end