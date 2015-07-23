class StudentsController < ApplicationController
    Pick Date 
<hr>
<% form_for @student do |f| -%>
   DATE: <%= f.text_field :DateRequired %><br />
   SUBMIT: <%= f.submit%>		
<% end -%>
</hr>

    
end
