import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String doctorName;

  const ChatScreen({Key? key, required this.doctorName}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();
  List<String> messages = []; // Lista de mensagens
  bool showEmojiPicker =
      false; // Estado para controlar a visibilidade do seletor de emojis

  void _sendMessage(String message) {
    setState(() {
      messages.add(message);
    });
    _messageController.clear(); // Limpa o campo de texto após enviar a mensagem
  }

  void _openEmojiSelector() {
    setState(() {
      showEmojiPicker =
          !showEmojiPicker; // Alternar visibilidade do seletor de emojis
    });
  }

  void _openAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Attach image'),
                onTap: () {
                  Navigator.pop(context);
                  _handleAttachment('image');
                },
              ),
              ListTile(
                leading: Icon(Icons.file_copy),
                title: Text('Attach document'),
                onTap: () {
                  Navigator.pop(context);
                  _handleAttachment('document');
                },
              ),
              // Adicione outras opções de anexo conforme necessário
            ],
          ),
        );
      },
    );
  }

  void _handleAttachment(String type) {
    // Implementar a lógica para lidar com o anexo do tipo selecionado
    print('Attachment type: $type');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.doctorName}'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(messages[index]),
                );
              },
            ),
          ),
          Divider(height: 1),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: Column(
              children: [
                if (showEmojiPicker)
                  Container(
                    height: 200, // Altura do seletor de emojis
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 8, // Quantidade de emojis por linha
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        // Emojis podem ser exibidos usando seu código Unicode
                        return InkWell(
                          onTap: () {
                            _messageController.text +=
                                String.fromCharCode(0x1F600 + index);
                          },
                          child: Center(
                            child: Text(
                              String.fromCharCode(0x1F600 + index),
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        );
                      },
                      itemCount:
                          56, // Quantidade total de emojis a serem exibidos
                    ),
                  ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.emoji_emotions),
                      onPressed: _openEmojiSelector,
                    ),
                    IconButton(
                      icon: Icon(Icons.attach_file),
                      onPressed: _openAttachmentMenu,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Send a message...',
                          ),
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _sendMessage(value);
                            }
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        String message = _messageController.text.trim();
                        if (message.isNotEmpty) {
                          _sendMessage(message);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
