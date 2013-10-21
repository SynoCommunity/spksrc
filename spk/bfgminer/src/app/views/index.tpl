%rebase layout request=request, status=status
<div class="well span9">
%if alert:
    <div class="alert alert-info">{{alert}}</div>
%end
    <h3>Control</h3>
    <form method="post" class="form-horizontal">
        <div class="control-group">
            <label class="control-label" for="pool_url">Pool URL</label>
            <div class="controls">
                <input type="text" id="pool_url" placeholder="uri:port">
            </div>
         </div>
         <button type="submit" class="btn btn-primary" 
                {{status not in ['Idle'] and 'disabled' or ''}}>
                {{status not in ['Idle'] and status or 'Run Now'}}</button>
    </form>
</div>
