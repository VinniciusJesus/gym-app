import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym/core/shared/theme/app_colors.dart';
import 'package:gym/core/shared/ui/primary_button.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

import '../../../../core/shared/ui/auth_input.dart';
import '../../../../core/shared/ui/card_widget.dart';
import '../../../../core/shared/ui/switch_tile.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileController>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<ProfileController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.2,
        centerTitle: true,
        title: const Text(
          'Perfil',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Form(
                key: c.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CardWidget(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundImage:
                                c.avatarUrl != null
                                    ? NetworkImage(c.avatarUrl!)
                                    : null,
                            backgroundColor: const Color(0xFFEDEFF2),
                            child:
                                c.avatarUrl == null
                                    ? const Icon(
                                      Icons.person_outline,
                                      size: 32,
                                      color: Color(0xFF8A94A6),
                                    )
                                    : null,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.nameEC.text.isEmpty
                                      ? 'Seu nome'
                                      : c.nameEC.text,
                                  style: const TextStyle(
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  c.emailEC.text.isEmpty
                                      ? 'seu@email.com'
                                      : c.emailEC.text,
                                  style: const TextStyle(
                                    color: AppColors.textSub,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton.icon(
                            onPressed: c.onChangeAvatar,
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primaryDark,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            label: const Text('Trocar foto'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    CardWidget(
                      title: 'Informações',
                      child: Column(
                        children: [
                          AuthInput(
                            controller: c.nameEC,
                            label: 'Nome',
                            hint: 'Seu nome completo',
                            validator: Validatorless.required(
                              'Informe seu nome',
                            ),
                          ),
                          const SizedBox(height: 10),
                          AuthInput(
                            controller: c.emailEC,
                            label: 'Email',
                            hint: 'voce@email.com',
                            readOnly: true,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 10),
                          AuthInput(
                            controller: c.birthEC,
                            label: 'Data de nascimento',
                            hint: 'dd/mm/aaaa',
                            keyboardType: TextInputType.datetime,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              DataInputFormatter(),
                            ],
                          ),
                          const SizedBox(height: 10),
                          AuthInput(
                            controller: c.weightEC,
                            label: 'Peso',
                            hint: 'Ex: 65.7',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              PesoInputFormatter(),
                            ],
                          ),
                          const SizedBox(height: 10),
                          AuthInput(
                            controller: c.heightEC,
                            label: 'Altura',
                            hint: 'Ex: 1.69',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              AlturaInputFormatter(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    CardWidget(
                      title: 'Preferências',
                      child: Column(
                        children: [
                          SwitchTile(
                            title: 'Notificações',
                            subtitle: 'Receber avisos e lembretes',
                            value: c.notifications,
                            onChanged: c.setNotifications,
                          ),
                          const Divider(height: 1),
                          SwitchTile(
                            title: 'Resumo semanal',
                            subtitle: 'Relatório com seus dados',
                            value: c.weeklySummary,
                            onChanged: c.setWeeklySummary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: 'Salvar alterações',
                      loading: c.saving,
                      onPressed: c.saving ? null : c.onSave,
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: c.onSignOut,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textSub,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Sair da conta'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
