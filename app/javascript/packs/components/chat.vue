<template>
    <div id="chat" class="chat">
        <ul class="messages" v-chat-scroll>
            <li class="message" v-for="n in messages">{{ n }}</li>
        </ul>
        <input type="text" class='input-box_text' v-model.trim="message" @keyup.enter="saveMessage()" />
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
                if(this.message !== '') {
                    this.$http.post(`/chats/${this.getChatToken()}/messages`,
                        {message: this.message},
                        {headers: {
                                'X-Auth-Token': localStorage.getItem('session_token'),
                                'X-CSRF-TOKEN': gon.csrf_token
                            }}
                    ).then(response => {
                        this.message = ''
                    });
                }
            },
            setStateRead() {
                this.$http.post(`/chats/${this.getChatToken()}/messages/set_state_read`,
                    {message: this.message},
                    {headers: {
                            'X-Auth-Token': localStorage.getItem('session_token'),
                            'X-CSRF-TOKEN': gon.csrf_token
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