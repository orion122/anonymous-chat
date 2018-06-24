<template>
    <div id="chat">
        <template v-for="message in messages">
            <p>
                {{ message }}
            </p>
        </template>
        <div class="footer">
            <div class="input-box">
                <input type="text" class='input-box_text' v-model="message" @keyup.enter="saveMessage()" />
            </div>
        </div>
    </div>
</template>

<script>
    export default {
        data() {
            return {
                message: '',
                messages: []
            }
        },
        mounted: function(){
            setInterval(() => {
                if (window.location.pathname == `/chats/${this.getChatToken()}`) {
                    this.getMessages()
                }
            }, 5000);
        },
        methods: {
            getMessages() {
                this.$http.get(`/chats/${this.getChatToken()}/messages`,
                    {headers: {
                            'X-Auth-Token': localStorage.getItem('session_token')
                        }}
                ).then(response => {
                    this.messages = response.body.reduce(((init, messageObject) => {
                        init.push(`${messageObject.session_id}: ${messageObject.message} (${messageObject.state})`)
                        return init
                    }), [])
                });
            },
            saveMessage() {
                this.$http.post(`/chats/${this.getChatToken()}/messages`,
                    {message: this.message},
                    {headers: {
                            'X-Auth-Token': localStorage.getItem('session_token'),
                            'X-CSRF-TOKEN': gon.csrf
                        }}
                ).then(response => {
                    this.message = ''
                });
            },
            setStateRead() {
                this.$http.post(`/chats/${this.getChatToken()}/messages/set_state_read`,
                    {message: this.message},
                    {headers: {
                            'X-Auth-Token': localStorage.getItem('session_token'),
                            'X-CSRF-TOKEN': gon.csrf
                        }}
                );
            },
            getChatToken() {
                return window.location.href.split('/').reverse()[0]
            }
        },
        watch: {
            message: function () {
                this.getMessages()
            },
            messages: function () {
                this.setStateRead()
            }
        }
    }
</script>