<?php

declare(strict_types=1);

namespace App\UserInterface\Web\Resolver;

use Symfony\Component\HttpFoundation\Request;
use App\UserInterface\Web\Request\UserRequest;
use Symfony\Component\Validator\Validator\ValidatorInterface;
use Symfony\Component\HttpKernel\Controller\ValueResolverInterface;
use Symfony\Component\HttpKernel\Exception\BadRequestHttpException;
use Symfony\Component\HttpKernel\ControllerMetadata\ArgumentMetadata;

class UserRequestResolver implements ValueResolverInterface
{
    public function __construct(private ValidatorInterface $validator)
    {
    }

    public function supports(Request $request, ArgumentMetadata $argument): bool
    {
        return $argument->getType() === UserRequest::class;
    }

    public function resolve(Request $request, ArgumentMetadata $argument): iterable
    {
        $data = json_decode($request->getContent(), true) ?? [];

        $userRequest = new UserRequest();
        $userRequest->first_name = $data['first_name'] ?? '';
        $userRequest->last_name = $data['last_name'] ?? '';
        $userRequest->birthdate = $data['birthdate'] ?? '';
        $userRequest->gender = $data['gender'] ?? '';

        $errors = $this->validator->validate($userRequest);

        if (count($errors) > 0) {
            $formattedErrors = [];
            foreach ($errors as $error) {
                $formattedErrors[$error->getPropertyPath()][] = $error->getMessage();
            }

            yield ['errors' => $formattedErrors];
            return;
        }

        yield $userRequest;
    }
}
