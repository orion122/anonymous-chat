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
                messages: [],
                current_session_token: localStorage.getItem('session_token')
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
                this.$http.get(`/chats/${this.getChatToken()}/messages`
                ).then(response => {
                    let userData = ''
                    this.messages = response.body.reduce(((init, messageObject) => {
                        userData = `${messageObject.nickname}: ${messageObject.message}`
                        if (messageObject.session_token === this.current_session_token) {
                            userData += `(${messageObject.state})`
                        }
                        init.push(userData)
                        return init
                    }), [])
                });
            },
            saveMessage() {
                if(this.message !== '') {
                    this.$http.post(`/chats/${this.getChatToken()}/messages`,
                        {message: this.message}
                    ).then(response => {
                        this.message = ''
                        this.getMessages()
                    });
                }
            },
            setStateRead() {
                this.$http.post(`/chats/${this.getChatToken()}/messages/set_state_read`,
                    {message: this.message}
                );
            },
            getChatToken() {
                return window.location.href.split('/').reverse()[0]
            }
        },
        watch: {
            messages: function () {
                this.setStateRead()
            }
        }
    }
</script>