using Azure.Messaging.ServiceBus;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace EnterpriseGuardrailPlatform.Functions;

public class QueueProcessor
{
    private readonly ILogger _logger;

    public QueueProcessor(ILoggerFactory loggerFactory)
    {
        _logger = loggerFactory.CreateLogger<QueueProcessor>();
    }

    [Function("QueueProcessor")]
    public void Run(
    [ServiceBusTrigger("demo-queue", Connection = "ServiceBusConnection")]
    ServiceBusReceivedMessage message)
    {
        _logger.LogInformation($"Message ID: {message.MessageId}");
        _logger.LogInformation($"Body: {message.Body}");
    }
}
