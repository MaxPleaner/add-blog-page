module ApplicationHelper
  def form_token
    <<-HTML.strip_heredoc
      <input type='hidden'
             name='authenticity_token'
             value='#{form_authenticity_token}'
      ></input>
    HTML
  end
end
